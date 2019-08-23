#include <chrono>
#include <cstdio>
#include <thread>

static constexpr auto main_loop_sleep_time = std::chrono::seconds(2);

int main() {
    printf("Hello World!!");
    std::this_thread::sleep_for(main_loop_sleep_time);
}
