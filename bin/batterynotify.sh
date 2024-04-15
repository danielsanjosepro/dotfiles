#
# Script to check battery status and notify user when battery is low.
#

echo "Running battery check script"


# Export some variables for the cron job
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

WARN_LEVEL=25
CRIT_LEVEL=15

# Get battery level
BATT_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')
BATT_DISCHARGING=$(acpi -b | grep -P -o 'Charging|Discharging')
BATT_FILE_DIR="$HOME/.tmp/batterystatus"

echo "Checking notification conditions"

# Check battery level
if [ $BATT_DISCHARGING == "Discharging" ]; then
    if [ $BATT_LEVEL -le $CRIT_LEVEL ]; then
        notify-send -u critical "Battery level is critical: $BATT_LEVEL%"
        echo "Battery level is critical: $BATT_LEVEL%"
    elif [ $BATT_LEVEL -le $WARN_LEVEL ] && [ -f "$BATT_FILE_DIR/BATTERY_LOW" ]; then
        echo "Battery level is low: $BATT_LEVEL% - already notified"
    elif [ $BATT_LEVEL -le $WARN_LEVEL ]; then
        notify-send -u normal "Battery level is low: $BATT_LEVEL%"
        echo "Battery level is low: $BATT_LEVEL%"
        # Save battery status to file
        touch "$BATT_FILE_DIR/BATTERY_LOW"
    else
        echo "Battery level is normal: $BATT_LEVEL%"
        rm -f "$BATT_FILE_DIR/BATTERY_LOW"
    fi
else 
    echo "Battery is charging"
    rm -f "$BATT_FILE_DIR/BATTERY_LOW"
fi
