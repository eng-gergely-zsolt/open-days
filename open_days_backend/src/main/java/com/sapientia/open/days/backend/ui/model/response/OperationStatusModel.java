package com.sapientia.open.days.backend.ui.model.response;

public class OperationStatusModel {
    private String operationName;
    private String operationResult;

    public String getOperationName() {
        return operationName;
    }

    public String getOperationResult() {
        return operationResult;
    }

    public void setOperationName(String operationName) {
        this.operationName = operationName;
    }

    public void setOperationResult(String operationResult) {
        this.operationResult = operationResult;
    }
}
