# 使用官方的 Node.js 镜像作为基础镜像
FROM node:16

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package*.json ./

# 安装依赖
RUN pnpm install

# 复制整个项目文件
COPY . .

# 构建项目（假设使用 Vue.js）
RUN pnpm build

# 设置静态文件服务器（使用 Nginx）
FROM nginx:alpine

# 复制构建的文件到 Nginx 的默认目录
COPY --from=0 /app/dist /usr/share/nginx/html

# 暴露容器端口
EXPOSE 8080

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]
