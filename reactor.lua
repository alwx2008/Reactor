local NumberOfNeutrons
local MaxNeutrons = 100000000000 -- 10e11
local ReactorPower = NumberOfNeutrons / MaxNeutrons

local NumberOfNeutrons -- Power now

local oldNumberOfNeutrons -- Power in previous timestep

local SomeFactors
local IdleNeutrons = 1000

NumberOfNeutrons = SomeFactors * (oldNumberOfNeutrons + IdleNeutrons)

local RodsPulled

SomeFactors = 2 * ( 0.2 + RodsPulled * 0.8 / 100)

local ReactorPeriod
local TimeStep -- number of seconds

ReactorPeriod = 1 / math.log( NumberOfNeutrons / oldNumberOfNeutrons) * 1 / TimeStep