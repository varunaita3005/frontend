# Stage 1: Build
FROM          docker.io/library/node:22 AS builder
WORKDIR       /app
COPY          ./ /app/
RUN           npm ci && npm run build
#
#FROM        sonarsource/sonar-scanner-cli AS sonar-scanner
#WORKDIR     /usr/src
#COPY        --from=builder /app /usr/src
#RUN         sonar-scanner \
#            -Dsonar.host.url=http://172.31.17.79:9000 \
#            -Dsonar.login=admin -Dsonar.password=admin123 -Dsonar.qualitygate.wait=true \
#            -Dsonar.projectKey=frontend \
#            -Dsonar.sources=. && \
#            touch /tmp/scan-success

FROM          docker.io/library/nginx
#COPY        --from=sonar-scanner /tmp/scan-success /tmp/
COPY          --from=builder /app/dist/assets/ /usr/share/nginx/html/assets/
COPY          --from=builder /app/dist/index.html /usr/share/nginx/html/index.html
COPY          nginx.conf /etc/nginx/nginx.conf