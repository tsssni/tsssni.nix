#pragma once

#define HEITZ_SPP 256
#define HEITZ_SOBOL_N 256
#define HEITZ_SOBOL_D 256
#define HEITZ_TILE_SIZE 128
#define HEITZ_TILE_D 8

extern const int sobol_256spp_256d[HEITZ_SOBOL_N * HEITZ_SOBOL_D];
extern const int scramblingTile[HEITZ_TILE_SIZE * HEITZ_TILE_SIZE * HEITZ_TILE_D];
extern const int rankingTile[HEITZ_TILE_SIZE * HEITZ_TILE_SIZE * HEITZ_TILE_D];
