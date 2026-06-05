# Replace [base-image] with your actual base image
# [baz-imaj] kısmını gerçek baz imajınızla değiştirin
# Examples: python:3.12-slim | rust:1.82-alpine | golang:1.23-alpine | node:22-alpine
FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Replace with your actual entry point / Gerçek giriş noktanızla değiştirin
CMD ["python", "main.py"]
