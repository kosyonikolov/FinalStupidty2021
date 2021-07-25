#include <algorithm>
#include <iostream>
#include <cstdint>
#include <array>
#include <queue>
#include <vector>

// For random init ONLY
#include <random>

// Alternative represantations that also get full points: 
// 1) uint8_t [][MAX_WIDTH]
// 2) vector<vector<uint8_t>>

static inline bool outOfRange(int x, int y, int w, int h)
{
    return x < 0 || y < 0 || x >= w || y >= h;
}

static inline int idx(int x, int y, int width)
{
    return y * width + x;
}

double bfs(const uint8_t * img, bool * seen, 
           const int width, const int height,
           const int sx, const int sy)
{
    struct Point 
    {
        int x, y;
    };

    double sum = 0;
    int cnt = 0;

    constexpr std::array<int, 8> dX = {-1,  0,  1, -1, 1, -1, 0, 1};
    constexpr std::array<int, 8> dY = {-1, -1, -1,  0, 0,  1, 1, 1};

    std::queue<Point> q;
    q.push({sx, sy});
    seen[idx(sx, sy, width)] = true;
 
    while (!q.empty())
    {
        const Point curr = q.front(); q.pop();
        sum += img[idx(curr.x, curr.y, width)];
        cnt++;

        for (int i = 0; i < dX.size(); i++)
        {
            const int nx = curr.x + dX[i];
            const int ny = curr.y + dY[i];
            const int iNext = idx(nx, ny, width);
            if (outOfRange(nx, ny, width, height) || img[iNext] == 0 || seen[iNext]) continue;
            seen[iNext] = true;
            q.push({nx, ny});            
        }
    }

    return sum / cnt;
}

void printRegions(const uint8_t * img, const int width, const int height)
{
    bool * seen = new bool[width * height];
    std::fill_n(seen, width * height, false);

    struct Region 
    {
        int x, y;
        double avg;
    };

    std::vector<Region> regions;

    for (int y = 0; y < height; y++)
    {
        for (int x = 0; x < width; x++)
        {
            const int cIdx = idx(x, y, width);
            if (seen[cIdx] || img[cIdx] == 0) continue;
            
            const double avg = bfs(img, seen, width, height, x, y);
            regions.push_back({x, y, avg});
        }
    }

    std::sort(regions.begin(), regions.end(), [](const Region & a, const Region & b)
              { return a.avg > b.avg; });

    for (const Region & r : regions) std::cout << "(" << r.x << ", " << r.y << ") " << r.avg << "\n";

    delete[] seen;
}

int main(int argc, char** argv) 
{
    if (argc < 3)
    {
        std::cerr << "Give args\n";
        return 1;
    }

    const int width = std::stoi(argv[1]);
    const int height = std::stoi(argv[2]);

    // Allocate
    uint8_t * img = new uint8_t[width * height];

    // Fill from somewhere, in this case at random
    {
        std::default_random_engine dre(std::random_device{}());
        std::uniform_int_distribution<uint8_t> valRng;
        std::uniform_real_distribution<float> zeroRng;

        for (int i = 0; i < width * height; i++)
        {
            if (zeroRng(dre) < 0.6) img[i] = 0;
            else img[i] = valRng(dre);
        }

        // Dump what we've created
        for (int y = 0; y < height; y++)
        {
            const uint8_t * line = img + y * width;
            for (int x = 0; x < width; x++) std::cout << uint32_t{line[x]} << "\t";
            std::cout << "\n";
        }
    }

    printRegions(img, width, height);
    delete[] img;
    return 0;
}
