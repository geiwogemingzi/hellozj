# 使用官方的 Node.js 镜像作为构建环境
FROM node:16-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装 pnpm
RUN npm install -g pnpm

# 复制 pnpm-lock.yaml 和 package.json
COPY pnpm-lock.yaml package.json ./

# 安装依赖
RUN pnpm install --frozen-lockfile

# 复制项目文件
COPY . .

# 构建前端项目
RUN pnpm run build

# 使用 Nginx 作为生产环境的 Web 服务器
FROM nginx:alpine

# 将构建好的静态文件复制到 Nginx 的默认目录
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]