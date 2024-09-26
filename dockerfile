# Stage 1: Build the SvelteKit application
FROM node:18 AS sveltekit-builder

# Set the working directory inside the container
WORKDIR /app

# Copy all project files into the container
COPY ./sk .

# Install Node dependencies
RUN npm install

# Build the SvelteKit project
RUN npm run build

FROM golang:1.23-alpine AS pocketbase-builder

# Set working directory for Go build
WORKDIR /app

COPY --from=sveltekit-builder /app/build /app/sk/build
COPY ./pb /app

RUN go mod tidy

# Build PocketBase
RUN go build

RUN ulimit -n 4096


EXPOSE 8090

# Run PocketBase, serving the SvelteKit build
CMD ["/app/pocketbase", "serve", "--http", "0.0.0.0:8090", "--publicDir=/app/sk/build", '--encryptionEnv="$(hexdump -vn16 -e'4/4 "%08X" 1 "\n"' /dev/urandom)']