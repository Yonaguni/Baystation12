#define AIR_BLOCKED 1
#define ZONE_BLOCKED 2
#define BLOCKED 3
#define FIRE_MINIMUM_TEMPERATURE_TO_EXIST 100+T0C
#define FIRE_MINIMUM_TEMPERATURE_TO_SPREAD 150+T0C
#define FIRE_SPREAD_RADIOSITY_SCALE 0.85
#define FIRE_GROWTH_RATE 40000
#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION)) //moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC
#define M_CELL_WITH_RATIO (MOLES_CELLSTANDARD * 0.005)
#define PLASMA_MINIMUM_BURN_TEMPERATURE 100+T0C