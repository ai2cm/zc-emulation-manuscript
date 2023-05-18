from typing import Union
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
import numpy as np
import os
import pandas as pd
import xarray as xr


WIDTH = 5.1
VERSION = "1"
plt.style.use("seaborn-colorblind")
MEMOIZE_DIR = "/home/andrep/repos/fv3net/projects/microphysics/docs/manuscript/cache"
FIG_DIR = "./figs"


land_color = "#bcb3a2"
RdBu_LAND = plt.get_cmap("RdBu_r")
RdBu_LAND.set_bad(land_color)

Viridis_LAND = plt.get_cmap("viridis")
Viridis_LAND.set_bad(land_color)


def _insert_white(key, new_key, position, bad_color=land_color):
    tmp = plt.get_cmap(key)(np.linspace(0, 1, 8))
    tmp[position] = [1.0, 1.0, 1.0, 1.0]
    cmap = LinearSegmentedColormap.from_list(new_key, tmp)
    cmap.set_bad(bad_color)

    return cmap


NuReds_LAND = _insert_white("Reds", "NuReds", 0)
NuBlues_LAND = _insert_white("Blues_r", "NuBlues", -1)

dt = 900  # s
seconds_per_day = 60 * 60 * 24  # seconds/min * min/hr * hr/day
m_to_mm = 1000

# from physcons.f
cp = 1.0046e3  # J / (kg K)
gravity = 9.80665  # m / s^2
lv = 2.5e6  # J / kg water
rho_water = 1000.0  # kg / m^3

# for use in regridding values to the same vertical grid [Pa]
# These are taken to match the levels of the ERA-Interim reanalysis dataset
# https://psl.noaa.gov/data/gridded/data.erainterim.html
PRESSURE_GRID = xr.DataArray(
    [
        300.0,
        500.0,
        700.0,
        1000.0,
        2000.0,
        3000.0,
        5000.0,
        7000.0,
        10000.0,
        12500.0,
        15000.0,
        17500.0,
        20000.0,
        22500.0,
        25000.0,
        30000.0,
        35000.0,
        40000.0,
        45000.0,
        50000.0,
        55000.0,
        60000.0,
        65000.0,
        70000.0,
        75000.0,
        77500.0,
        80000.0,
        82500.0,
        85000.0,
        87500.0,
        90000.0,
        92500.0,
        95000.0,
        97500.0,
        100000.0,
    ],
    dims="pressure",
)

x = range(0, 70, 2)
x2 = range(0, 70)
yp = np.interp(x2, x, PRESSURE_GRID)
LEVELS = xr.DataArray(yp[:-1], dims=["pressure"])


def kg_m2_s_to_mm_day(da):
    return da * seconds_per_day / rho_water * m_to_mm


def kg_m2_to_mm(da):
    return da / rho_water * m_to_mm


def m_to_mm_day(da):
    return da / dt * m_to_mm * seconds_per_day


def kg_kg_s_to_g_kg_day(da):
    return da * seconds_per_day * 1000


def kg_kg_s_to_mg_kg_day(da):
    return da * seconds_per_day * 1e6

def limit_sigfigs(df: Union[pd.DataFrame, pd.Series], num_sigfigs=3):
    power_offset = -np.floor(np.log10(np.abs(df))).astype(int)
    to_round = df * 10.0 ** power_offset
    return to_round.round(num_sigfigs - 1) * 10.0 ** -power_offset


def savefig(filename):
    plt.savefig(os.path.join(FIG_DIR, filename + ".png"), bbox_inches="tight")
    plt.savefig(os.path.join(FIG_DIR, filename + ".pdf"), bbox_inches="tight")
