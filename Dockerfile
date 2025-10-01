# syntax=docker/dockerfile:1

# ============================================
# Stage 1: Builder - Install dependencies
# ============================================
FROM node:24-alpine AS builder

WORKDIR /build

# Install ESLint and common plugins globally
RUN npm install -g --prefix /usr/local \
    eslint \
    @eslint/js \
    @stylistic/eslint-plugin

# ============================================
# Stage 2: Runtime - Minimal image
# ============================================
FROM alpine:latest

# Install only the absolute minimum runtime dependencies
# Node.js requires: libstdc++, libgcc
RUN apk add --no-cache \
    libstdc++ \
    libgcc \
    # Remove apk package manager after installation
    && rm -rf /sbin/apk \
    /etc/apk \
    /lib/apk \
    /usr/share/apk \
    /var/cache/apk/*

# Copy Node.js binary from official image
COPY --from=node:24-alpine /usr/local/bin/node /usr/local/bin/node
COPY --from=node:24-alpine /usr/local/lib/node_modules /usr/local/lib/node_modules

# Create symlink for npm (needed for dependency installation in projects)
RUN ln -s /usr/local/lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm && \
    ln -s /usr/local/lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx

# Copy ESLint and its dependencies from builder
COPY --from=builder /usr/local/lib/node_modules /usr/local/lib/node_modules

# Create ESLint symlink (the bin/eslint is just a symlink to the actual module)
RUN ln -s /usr/local/lib/node_modules/eslint/bin/eslint.js /usr/local/bin/eslint

# Create non-root user without unnecessary tools
RUN addgroup -g 1001 -S nodejs && \
    adduser -S eslint -u 1001 -G nodejs -s /sbin/nologin -D

# Create workspace directory
RUN mkdir -p /workspace && chown -R eslint:nodejs /workspace

# Switch to non-root user
USER eslint

# Set workspace as working directory
WORKDIR /workspace

# Create entrypoint script that installs local deps if needed
USER root
COPY <<EOF /usr/local/bin/eslint-entrypoint.sh
#!/bin/sh
set -e

# If package.json exists, install dependencies
if [ -f "package.json" ]; then
    echo "Installing project dependencies..."
    npm install --silent
fi

# Run eslint with all arguments
exec eslint "\$@"
EOF

RUN chmod +x /usr/local/bin/eslint-entrypoint.sh && \
    chown eslint:nodejs /usr/local/bin/eslint-entrypoint.sh

USER eslint

# Use entrypoint script
ENTRYPOINT ["/usr/local/bin/eslint-entrypoint.sh"]

# Default to showing help
CMD ["--help"]