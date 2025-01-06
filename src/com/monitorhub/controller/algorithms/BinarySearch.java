/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.monitorhub.controller.algorithms;

import com.monitorhub.model.MonitorDetails;
import java.util.List;

/**
 *
 * @author Prajol
 */
public class BinarySearch {
    public static int searchByModelName(List<MonitorDetails> list, String targetModelName) {
        int low = 0;
        int high = list.size() - 1;

        while (low <= high) {
            int mid = low + (high - low) / 2;
            String midModelName = list.get(mid).getModelName().toLowerCase();

            if (midModelName.equals(targetModelName)) {
                return mid; // Found
            } else if (midModelName.compareTo(targetModelName) < 0) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }

        return -1; // Not found
    }
}
