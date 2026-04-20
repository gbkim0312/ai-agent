# Docker / OMV 배포 가이드

이 프로젝트는 웹 앱 중심으로 Docker 컨테이너에서 실행하는 구성을 기준으로 정리함.

## 1. 구성 개요

- 애플리케이션: Spring Boot 웹 앱
- 내부 포트: 8081
- 영속 데이터: `/app/data`
- DB: H2 파일 모드 (`/app/data/agentdb`)
- 파일 업로드/RAG 인덱스: `/app/data` 하위에 저장됨

## 2. 로컬 빌드

```bash
docker build -t ai-agent-web:local .
```

## 3. Compose 실행

프로젝트 루트에서 환경변수를 준비한 뒤 실행함.

### Gemini 프로파일

```bash
export APP_MODEL_PROFILE="gemini"
export GEMINI_API_KEY="your-key"
export APP_SECURITY_USERNAME="inhouse"
export APP_SECURITY_PASSWORD="change-this-password"
docker compose up -d --build
```

### OpenAI 프로파일

```bash
export APP_MODEL_PROFILE="openai"
export OPENAI_API_KEY="your-openai-key"
export APP_SECURITY_USERNAME="inhouse"
export APP_SECURITY_PASSWORD="change-this-password"
docker compose up -d --build
```

## 4. OMV 권장 방식

- OMV의 공유 폴더 아래에 이 프로젝트를 배치함
- `WEBAPP_DATA_DIR`를 OMV 공유 폴더 경로에 맞춰 지정함
- 예시:

```bash
export WEBAPP_DATA_DIR=/srv/dev-disk-by-uuid-xxxx/appdata/ai-agent-web
docker compose up -d
```

## 5. 접속

- 웹 앱: `http://서버IP:8081`
- H2 콘솔: `APP_H2_CONSOLE_ENABLED=true`일 때만 `/h2-console`

## 6. 운영 팁

- 기본 로그인 계정은 환경변수 `APP_SECURITY_USERNAME`, `APP_SECURITY_PASSWORD`로 지정함
- 모델 공급자는 `APP_MODEL_PROFILE=gemini` 또는 `APP_MODEL_PROFILE=openai` 로 선택함
- 공식 OpenAI API는 `OPENAI_API_KEY`를 사용하며, 필요 시 `OPENAI_BASE_URL`로 호환 엔드포인트를 지정할 수 있음
- 외부 공개 시 H2 콘솔은 비활성화 상태를 유지하는 것이 안전함
- 역방향 프록시(Nginx Proxy Manager 등)를 붙일 경우 외부는 80/443, 내부는 8081로 연결하면 됨