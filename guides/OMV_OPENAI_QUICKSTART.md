# OMV OpenAI 실행 방법

이 문서는 main 머지 전 상태에서 `openai-integration` 브랜치를 OMV 서버에 배포해 실행하는 최소 절차만 정리함.

## 1. 서버 접속

```bash
ssh root@<OMV_HOST> -p <SSH_PORT>
```

예시:

```bash
ssh root@gibeom.tplinkdns.com -p 55
```

## 2. 작업 디렉터리 이동

```bash
mkdir -p /root/docker/dockfile/ai-agent
cd /root/docker/dockfile/ai-agent
```

## 3. 저장소 clone

```bash
git clone <YOUR_GIT_REMOTE_URL> .
```

이미 clone 되어 있으면 아래만 실행:

```bash
git fetch origin
```

## 4. 머지 전 브랜치 checkout

```bash
git fetch origin openai-integration
git checkout -B openai-integration origin/openai-integration
```

현재 브랜치 확인:

```bash
git branch --show-current
```

정상 결과:

```bash
openai-integration
```

## 5. 데이터 디렉터리 준비

```bash
mkdir -p /root/docker/dockfile/ai-agent-data
```

## 6. 환경파일 생성

예시 파일 복사:

```bash
cp .env.docker.example .env.docker
```

편집:

```bash
vi .env.docker
```

권장 값:

```env
APP_MODEL_PROFILE=openai
GEMINI_API_KEY=
OPENAI_API_KEY=your-real-openai-key
OPENAI_BASE_URL=https://api.openai.com/v1/
APP_SECURITY_USERNAME=admin
APP_SECURITY_PASSWORD=change-this-password
APP_H2_CONSOLE_ENABLED=false
WEBAPP_BIND_PORT=28081
WEBAPP_DATA_DIR=/root/docker/dockfile/ai-agent-data
SPRING_DATASOURCE_URL=jdbc:h2:file:/app/data/agentdb
SPRING_DATASOURCE_USERNAME=sa
SPRING_DATASOURCE_PASSWORD=
```

## 7. Docker Compose 실행

```bash
docker compose --env-file .env.docker up -d --build
```

## 8. 상태 확인

```bash
docker compose ps
docker compose logs -f ai-agent-web
```

## 9. 접속

```text
http://<OMV_HOST>:28081/login
```

예시:

```text
http://gibeom.tplinkdns.com:28081/login
```

## 10. 업데이트

새 커밋 반영:

```bash
cd /root/docker/dockfile/ai-agent
git fetch origin
git checkout openai-integration
git pull --ff-only origin openai-integration
docker compose --env-file .env.docker up -d --build
```

## 11. 중지/재시작

중지:

```bash
docker compose --env-file .env.docker down
```

재시작:

```bash
docker compose --env-file .env.docker up -d
```