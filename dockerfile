# ──────────────────────────────────────────────
# 🧩 STAGE 1: BUILD FRONTEND (Vue)
# ──────────────────────────────────────────────
# ใช้ Ubuntu เป็น base image ตามที่โจทย์กำหนด
FROM ubuntu:22.04 AS build

# ติดตั้ง curl และ git
RUN apt update && apt install -y curl git

# ติดตั้ง Node.js 18.x และ npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# ตั้งค่าโฟลเดอร์หลักใน container
WORKDIR /app

# คัดลอกโค้ดฝั่ง frontend (Vue) เข้าไปใน container
COPY client ./client

# ติดตั้ง dependencies และ build Vue project
# - npm install → ติดตั้งแพ็กเกจทั้งหมด (vue, vue-router ฯลฯ)
# - npm run build → สร้างไฟล์ production (dist/)
RUN cd client && npm install && npm run build

# ตรวจสอบว่าไฟล์ build ถูกสร้างใน client/dist
RUN echo "=== Checking client/dist after build ===" && ls -la /app/client/ && ls -la /app/client/dist/ || echo "dist folder not found!"

# ──────────────────────────────────────────────
# 🧩 STAGE 2: BACKEND (Express + Socket.io)
# ──────────────────────────────────────────────
# ใช้ Ubuntu base อีกครั้ง (คนละ stage เพื่อให้ image เล็กลง)
FROM ubuntu:22.04

# ติดตั้ง Node.js + npm เพื่อใช้รัน Express server
RUN apt update && apt install -y curl git
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# ตั้งค่าโฟลเดอร์หลัก
WORKDIR /app

# คัดลอกโค้ดฝั่ง backend (Express + Socket.io)
COPY server ./server

# คัดลอกผลลัพธ์การ build ของ Vue (จาก stage build ก่อนหน้า)
# ไปไว้ใน /app/server/public
#  → Express จะใช้เสิร์ฟไฟล์ static จากโฟลเดอร์นี้
COPY --from=build /app/client/dist ./server/public

# ตรวจสอบว่าไฟล์ถูก copy มาที่ server/public
RUN echo "=== Checking server/public after COPY ===" && ls -la /app/server/public/ || echo "public folder not found!"

# เข้าสู่โฟลเดอร์ server และติดตั้ง dependencies ของ backend
# เช่น express, socket.io, mongoose
WORKDIR /app/server
RUN npm install

# เปิดพอร์ต 3000 เพื่อให้ container ภายนอกเข้าถึงได้
EXPOSE 3000

# คำสั่งเริ่มต้นเมื่อ container ถูกสตาร์ท
# ให้รัน Express server (index.js)
CMD ["node", "index.js"]
