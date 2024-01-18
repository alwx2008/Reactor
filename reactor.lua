local NumberOfNeutrons -- Power now
local MaxNeutrons = 100000000000 -- 10e11
local ReactorPower = NumberOfNeutrons / MaxNeutrons

local oldNumberOfNeutrons -- Power in previous timestep

local SomeFactors
local IdleNeutrons = 1000

NumberOfNeutrons = SomeFactors * (oldNumberOfNeutrons + IdleNeutrons)

local RodsPulled

SomeFactors = 2 * ( 0.2 + RodsPulled * 0.8 / 100)

local ReactorPeriod
local TimeStep -- number of seconds

ReactorPeriod = 1 / math.log( NumberOfNeutrons / oldNumberOfNeutrons) * 1 / TimeStep

local WaterDensity = 1000

SomeFactors = 2 * ( 0.2 + RodsPulled * 0.8 / 100 ) * WaterDensity / 1000

-- Xenon and Iodine

local iodine
local xenon
local iodineDecay
local ScalingFactor = 0.00025

iodine = iodine + NumberOfNeutrons / MaxNeutrons * ScalingFactor
iodineDecay = iodine * ScalingFactor
iodine = iodine - iodineDecay

xenon = xenon + iodineDecay
xenon = xenon - 2 / 3 * xenon * ScalingFactor * TimeStep
xenon = xenon - xenon * NumberOfNeutrons / MaxNeutrons * ScalingFactor

-- Fuel

local FuelRemaining = math.random(0, 100) -- in percent

SomeFactors = 2 * ( 0.2 + RodsPulled * 0.8 / 100 ) * WaterDensity / 1000 * FuelRemaining * ( 1 - xenon / 4.5 )

-- Steam voids

local VoidCoefficient = 1 - 0.3 * NumberOfNeutrons / MaxNeutrons

SomeFactors = 2 * ( 0.2 + RodsPulled * 0.8 / 100 ) * WaterDensity / 1000 * FuelRemaining * ( 1 - xenon / 4.5 ) * VoidCoefficient

-- Water heating

local WaterTemperature = 20
local HeatPerPower = 10 -- degrees per timestep for 100% reactor power

WaterTemperature = WaterTemperature + NumberOfNeutrons / MaxNeutrons * HeatPerPower

-- Water boiling

function CalculateBoilingPoint( pressure ) -- pressure in Pa
    pressure = pressure * 10

    if pressure/10000000>20 then -- above this physics breaks down
        pressure = 20*10000000
    end

    local temperature = 1.0002646407033929 * 10^2 + 1.2485512687579338 * 10^( -05 ) * pressure - 6.0865396119409739 * 10^( -13 ) * pressure^2 + 1.8961630152963698 * 10^( -20 ) * pressure^3 - 3.4939669493500672 * 10^( -28 ) * pressure^4 + 3.8256436415169860 * 10^( -36 ) * pressure^5 - 2.4385640912095220 * 10^( -44 ) * pressure^6 + 8.3341353038170792 * 10^( -53 ) * pressure^7 - 1.1778965239174813 * 10^( -61 ) * pressure^8
    return temperature -- temperature in C
end

local WaterAmount
local SteamAmount
local WaterTemperature
local TemperatureSurplus
local SaturationTemperature
local BoilingCoefficient -- Tune this
local AmountBoiled
local Pressure
local SteamPressureCoefficient -- Tune this

if WaterTemperature > SaturationTemperature then
    TemperatureSurplus = WaterTemperature - SaturationTemperature
    AmountBoiled = TemperatureSurplus * BoilingCoefficient

    WaterTemperature = SaturationTemperature

    WaterAmount = WaterAmount - AmountBoiled
    SteamAmount = SteamAmount + AmountBoiled

    Pressure = SteamAmount + SteamPressureCoefficient * ( WaterTemperature + 273 ) / 373

    SaturationTemperature = CalculateBoilingPoint( Pressure ) -- update for next timestep
end

function CalculateWaterDensity( temperature ) -- temperature in C
    local density = -0.000004467711 * temperature^3 - 0.000560288485 * temperature^2 - 0.429148844451 * temperature + 1010.035413387815

    return density
end

WaterDensity = CalculateWaterDensity( WaterTemperature )

local WaterLevel
local AmountToLevelCoefficient -- Tune this

WaterLevel = WaterAmount / WaterDensity * AmountToLevelCoefficient

-- Feedwater