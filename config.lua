Config = {
    -- Vehicle Control Settings
    vehicle = {
        maxRpm = 0.2,                 -- Maximum RPM limit for throttle control
        maxSpeed = 80,                -- Speed limit (km/h) above which throttle control won't affect vehicles
        defaultSmoothingEnabled = false, -- If true, throttle control is enabled by default
    },

    -- Better Vehicle Handling Features
    features = {
        -- Rollback System
        rollback = {
            enabled = true,
            duration = 30,            -- Duration of rollback effect
            strength = 10             -- Force multiplier for rollback
        },
        
        -- Enhanced Handbrake Turns
        handbrake = {
            enabled = true,
            strength = 1.5            -- Force multiplier for handbrake turns
        }
    },

    -- Controls
    controls = {
        throttleControl = {
            key = 'lshift',          -- Key to toggle throttle control
            label = 'Toggle Throttle Control'
        }
    },

    -- Vehicle Class Permissions
    allowedVehicleClasses = {
        [0] = true,     -- Compacts
        [1] = true,     -- Sedans
        [2] = true,     -- SUVs
        [3] = true,     -- Coupes
        [4] = true,     -- Muscle
        [5] = true,     -- Sports Classics
        [6] = true,     -- Sports
        [7] = true,     -- Super
        [8] = true,     -- Motorcycles
        [9] = true,     -- Off-road
        [10] = false,   -- Industrial
        [11] = false,   -- Utility
        [12] = false,   -- Vans
        [13] = false,   -- Cycles
        [14] = false,   -- Boats
        [15] = false,   -- Helicopters
        [16] = false,   -- Planes
        [17] = false,   -- Service
        [18] = true,    -- Emergency
        [19] = false,   -- Military
        [20] = false,   -- Commercial
        [21] = false    -- Trains
    }
}