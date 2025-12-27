#include <iostream>
#include <vector>

int main() {
    std::vector<std::vector<int>> grid(8, std::vector<int>(10, 0));
    std::cout << "地图创建成功！大小：" 
              << grid.size() << "x" << grid[0].size() << std::endl;
    return 0;
}
