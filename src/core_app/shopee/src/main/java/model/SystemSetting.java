package model;

import java.sql.Timestamp;

public class SystemSetting {
    private String settingKey;
    private String settingValue;
    private String description;
    private String settingGroup;
    private Timestamp updatedAt;

    public SystemSetting() {
    }

    public SystemSetting(String settingKey, String settingValue, String description, String settingGroup, Timestamp updatedAt) {
        this.settingKey = settingKey;
        this.settingValue = settingValue;
        this.description = description;
        this.settingGroup = settingGroup;
        this.updatedAt = updatedAt;
    }

    public String getSettingKey() {
        return settingKey;
    }

    public void setSettingKey(String settingKey) {
        this.settingKey = settingKey;
    }

    public String getSettingValue() {
        return settingValue;
    }

    public void setSettingValue(String settingValue) {
        this.settingValue = settingValue;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getSettingGroup() {
        return settingGroup;
    }

    public void setSettingGroup(String settingGroup) {
        this.settingGroup = settingGroup;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}
