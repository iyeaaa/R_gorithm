/**
* 메모리: 5016 KB, 시간: 184 ms
* 2022.08.22
* by Alub
*/
#include <cstdio>
#include <algorithm>
using namespace std;

int N, x, answer, LIS[1000001];

int main() {
    scanf("%d", &N);
    for(int i = 1; i <= N; i++) {
        scanf("%d", &x);
        LIS[x] = LIS[x-1] + 1;
        answer = max(answer, LIS[x]);
    }
    printf("%d", N-answer);
}