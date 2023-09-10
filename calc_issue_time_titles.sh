#!/bin/bash 

# ./calc_issue_time_titles.sh "repo:sgc-snft/snm-all is:issue closed:2023-07-26T00:00:00+09:00..2023-08-25T23:59:59+09:00"
# ./calc_issue_time_titles.sh "repo:sgc-snft/snm-all is:issue is:open updated:2023-07-26T00:00:00+09:00..2023-08-25T23:59:59+09:00"
# 指定した期間にクローズしたissueから 1h のような形式のコメントを抽出して、数値部分を合計する。
"$(gh api graphql -F owner=$OWNER -F name=$REPO -F queryString="$@" --paginate -f query='
            query($endCursor: String, $queryString: String!) {
              search(query: $queryString, type: ISSUE, first: 100, after: $endCursor) {
              edges {
                node {
                  ... on Issue {
                    title
                    closedAt
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
            }' | jq -r '.data.search.edges[].node.title')"


