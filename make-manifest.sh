#!/bin/sh

# 출력 파일
OUT="tools-manifest.json"

# 제외할 파일들 (basename 기준)
EXCLUDE_REGEX='^(index\.html|404\.html)$'

# html 파일 찾기
# - .git 디렉토리 제외
# - 상대경로로 출력
FILES=$(find . \
  -type d -name .git -prune -o \
  -type f -name "*.html" -print \
  | sed 's|^\./||' \
  | while read -r f; do
      base=$(basename "$f")
      echo "$base" | grep -Eq "$EXCLUDE_REGEX" && continue
      echo "$f"
    done \
  | sort)

# JSON 생성
{
  echo "{"
  echo '  "html": ['

  first=1
  echo "$FILES" | while read -r f; do
    [ -z "$f" ] && continue
    if [ $first -eq 1 ]; then
      first=0
      printf '    "%s"' "$f"
    else
      printf ',\n    "%s"' "$f"
    fi
  done

  echo
  echo "  ]"
  echo "}"
} > "$OUT"

echo "생성 완료: $OUT"

