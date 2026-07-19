---
title: Vercel Deployment Guide
last_updated: 2026-07-19
status: active
---

# Vercel Deployment Guide

이 가이드는 `presence-ego` 블로그를 Vercel 플랫폼에 배포하고 관리하는 방법을 설명합니다.

## Prerequisites

- [GitHub](https://github.com) 계정 및 본 프로젝트의 원격 저장소(`https://github.com/haloroom/presence-ego`) 권한
- [Vercel](https://vercel.com) 계정 (GitHub 계정으로 가입 권장)

## Deployment Steps

### 1. Vercel 프로젝트 생성

1. [Vercel 대시보드](https://vercel.com/dashboard)에 접속하여 로그인합니다.
2. 우측 상단의 **"Add New..."** 버튼을 누르고 **"Project"**를 선택합니다.
3. GitHub 저장소 목록에서 `haloroom/presence-ego`를 찾아 **"Import"** 버튼을 클릭합니다.

### 2. 빌드 및 설정 구성

Vercel은 Astro 프로젝트를 자동으로 인식하여 최적의 기본 설정을 채택합니다. 아래 설정이 올바른지 확인합니다.

- **Framework Preset**: `Astro`
- **Root Directory**: `./` (기본값)
- **Build and Output Settings**:
  - Build Command: `npm run build` 또는 `astro build`
  - Output Directory: `dist`
  - Install Command: `npm install` 또는 `yarn install`

> [!NOTE]
> 본 프로젝트는 정적 사이트 생성(SSG)으로 빌드되므로, 별도의 서버리스 환경설정이나 환경변수(Environment Variables) 정의 없이 바로 배포할 수 있습니다.

### 3. 배포(Deploy) 실행

1. 하단의 **"Deploy"** 버튼을 클릭합니다.
2. 약 1~2분 정도 빌드가 진행된 후 배포가 완료됩니다.
3. 배포 완료 시 Vercel에서 무료 제공하는 서브도메인(예: `presence-ego.vercel.app`)으로 즉시 접속이 가능합니다.

## CI/CD 자동화

원격 저장소 연동이 완료되었으므로 다음과 같은 CI/CD 흐름이 자동으로 작동합니다.

- **Production 배포**: `main` 브랜치에 코드를 푸시하거나 풀 리퀘스트(PR)를 머지하면, Vercel이 이를 감지하여 자동으로 프로덕션 사이트를 갱신합니다.
- **Preview 배포**: `main`이 아닌 다른 브랜치에 푸시하거나 PR을 생성하면, 검토용 임시 미리보기 URL을 생성해 줍니다.

## 도메인 연결 (선택사항)

개인 도메인을 연결하려면:
1. Vercel 프로젝트 대시보드 -> **Settings** -> **Domains**로 이동합니다.
2. 원하는 도메인 주소를 입력하고 **Add**를 누릅니다.
3. Vercel이 제시하는 DNS 설정 정보(CNAME 또는 Nameservers)를 도메인 구매 대행 업체 설정에 등록합니다.
