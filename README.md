# 중앙대 교내 규정 조회 MCP 설치

중앙대학교 교내 규정 390개를 Claude(데스크톱 앱, Claude Code)와 Codex에서 읽기 전용으로 조회하게 연결합니다. **교내망(165.194.0.0/16) 또는 학교 VPN**에서만 동작하며, 토큰이나 로그인은 없습니다.

- 사람용 설명서(Notion): https://thin-airedale-e07.notion.site/MCP-41716620cc2a81939a5bea12bdd1196d
- 서버: `https://165.194.61.71:8445/mcp` (자체 서명 인증서, 2026-11-16 재발급, 이 서버만 증명(CA:FALSE), 만료 2029-02-13)

## 사람이 직접 설치할 때 (Windows)

교내망에 연결한 PC의 PowerShell에 아래 한 줄을 붙여 넣습니다. Node.js가 없어도 스크립트가 자동으로 설치합니다.

```powershell
irm https://raw.githubusercontent.com/kenblessyou/cau-regulations-mcp-install/main/install-cau-regulations.ps1 -OutFile "$env:USERPROFILE\Downloads\install-cau-regulations.ps1"; powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\install-cau-regulations.ps1"
```

설치 중 Windows 보안 경고 창("인증서를 설치하시겠습니까?")이 뜨면 **예**를 누릅니다. 이 서버 인증서를 이 PC 사용자에게만 신뢰 등록해, 브라우저로 https://165.194.61.71:8445/ 를 열 때 경고가 나오지 않게 합니다. **아니요**를 눌러도 Claude 연결은 동작합니다.

끝나면 Claude 데스크톱 앱을 트레이 아이콘까지 완전히 종료했다가 다시 엽니다. 도구 목록에 `cau-regulations`가 보이면 됩니다. Chrome·Edge도 다시 엽니다.

2026-11-13~15에 설치한 PC는 서버 인증서가 바뀌어 `서버 인증서가 맞지 않습니다`가 나옵니다. 위 한 줄을 다시 실행하면 됩니다.

Mac은 Notion 설명서 5번(연결 프로그램 방식)을 따르세요.

## AI 에이전트용 설치 절차

사용자가 이 저장소 주소를 주고 설치를 요청하면 다음을 따르세요.

1. 대상: Windows + Claude 데스크톱 앱/Claude Code/Codex. 토큰이 필요 없습니다. `access-token.txt`를 요구하는 이전 8444 꾸러미는 쓰지 마세요.
2. 스크립트: `install-cau-regulations.ps1` (원문: https://raw.githubusercontent.com/kenblessyou/cau-regulations-mcp-install/main/install-cau-regulations.ps1). 연결 프로그램·`config.json`·`server-cert.pem`이 gzip+base64로 들어 있어 다른 파일이 필요 없습니다. ASCII만 쓰므로 인코딩 문제가 없습니다.
3. 실행:
   - 사용자 PC의 셸을 직접 쓸 수 있으면(Claude Code, Codex, 로컬 세션): 위 "사람이 직접 설치할 때"의 한 줄을 PowerShell에서 실행합니다.
   - 사용자 PC 셸을 쓸 수 없으면(클라우드 세션 등): 위 한 줄을 사용자에게 주고 교내망 PC의 PowerShell에 붙여 넣게 합니다. 원격 장치 도구로 `~/Downloads`에 파일을 쓸 수 있으면 원문을 받아 저장한 뒤 `powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\Downloads\install-cau-regulations.ps1"`만 안내해도 됩니다.
4. 스크립트가 하는 일: Node.js 18+ 확인(없으면 winget으로 LTS 설치, winget이 없거나 실패하면 관리자 권한 없이 `%LOCALAPPDATA%\cau-regulations-node`에 포터블 LTS 설치) → `%USERPROFILE%\cau-regulations-client`에 설치(기존 폴더 백업) → `--check` 연결 시험(실패하면 설정을 바꾸지 않고 중단) → 서버 인증서를 현재 사용자의 신뢰할 수 있는 루트에 등록(Windows 확인 창, 이전 서버 인증서는 제거, 거절해도 계속) → Claude 데스크톱 앱 설정 등록(Store 설치판 경로 포함, 원본 백업) → Claude Code 사용자 범위 등록(설치된 경우) → Codex `config.toml` 등록(있는 경우, 중복이면 건너뜀).
5. 성공하면 Claude 데스크톱 앱 완전 재시작, 실행 중인 Claude Code·Codex 세션 재시작, 브라우저 재시작을 안내합니다. Windows 인증서 확인 창에서 **예**를 눌러야 한다고 미리 알려 주세요.

## 문제 해결

| 오류 문구 | 원인과 조치 |
| --- | --- |
| 서버에 연결할 수 없습니다 | 교내망 또는 학교 VPN이 아님 |
| 교내망에서만 접속할 수 있습니다(403), Connection test failed | 접속 IP가 허용 대역 밖. 사무실 공유기(192.168.x.x)나 교내 무선망에 연결된 PC는 학교 유선망 또는 VPN으로 접속하거나, 관리자에게 `ipconfig`의 IPv4 주소 전달 |
| 브라우저의 "연결이 비공개로 설정되어 있지 않습니다" | 설치 중 인증서 확인 창에서 아니요를 눌렀거나 원클릭 설치를 하지 않은 PC. 스크립트를 다시 실행해 예를 누르거나, 고급 → 이동(안전하지 않음) |
| 요청이 너무 많아 잠시 막혔습니다(429) | 분당 120회 초과. 1분 뒤 재시도 |
| 서버 인증서가 맞지 않습니다 | 이 저장소의 최신 스크립트로 다시 설치 |
| Automatic Node.js install failed | 인터넷(nodejs.org) 접근이 막힌 경우. https://nodejs.org 에서 LTS를 설치한 뒤 다시 실행 |
| 앱에 도구가 안 보임 | 앱을 트레이까지 완전히 종료 후 재시작 |

## 유의

- 이 도구는 규정 원문 조회용이며 해석이나 적용 판단을 대신하지 않습니다. 업무 판단 전에는 원문 PDF와 소관 부서를 확인하세요.
- Claude나 Codex로 조회하면 조회 결과는 해당 AI 서비스로 전달됩니다.
- 서버 주소, 인증서, 연결 프로그램이 바뀌면 관리자가 이 스크립트를 새 꾸러미로 다시 만들어 올립니다.
