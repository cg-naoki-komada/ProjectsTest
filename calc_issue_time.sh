#!/bin/bash 

# ./calc_issue_time.sh  "repo:cg-naoki-komada/ProjectsTest is:issue is:closed closed:2023-06-02T18:00:00+09:00..2023-06-05T23:00:00+09:00 "
# ./calc_issue_time.sh  "repo:sgc-snft/snm-all is:issue is:closed closed:2023-05-26T00:00:00+09:00..2023-06-25T23:59:59+09:00"
# 指定した期間にクローズしたissueから 1h のような形式のコメントを抽出して、数値部分を合計する。
countedHour="$(gh api graphql -F owner=$OWNER -F name=$REPO -F queryString="$@" --paginate -f query='
            query($endCursor: String, $queryString: String!) {
              search(query: $queryString, type: ISSUE, first: 100, after: $endCursor) {
              edges {
                node {
                  ... on Issue {
                    comments(first: 100) {
                      edges {
                        node {
                          body
                        }
                      }
                    }
                  }
                }
              }
              pageInfo {
                hasNextPage
                endCursor
              }
            }
            }' | jq '[.data.search.edges[].node.comments.edges[].node | select(.body | test("^\\d+[h].*$")) | (.body | sub("[h].*$"; "")) | tonumber] | add')"

echo 'COUNTED_HOUR='$countedHour
