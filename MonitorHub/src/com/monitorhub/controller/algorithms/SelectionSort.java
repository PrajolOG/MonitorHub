/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.monitorhub.controller.algorithms;

import com.monitorhub.model.MonitorDetails;

import java.util.ArrayList;

/**
 *
 * @author Prajol Bimali
 * LMU ID: 23048651
 */

public class SelectionSort {

    /**
     * Sorts an ArrayList of MonitorDetails objects by their amount in ascending or descending order.
     *
     * @param monitorList The ArrayList of MonitorDetails objects to be sorted.
     * @param highToLow   If true, sorts in descending order (highest amount first); 
     *                    if false, sorts in ascending order (lowest amount first).
     */
    public void sortByAmount(ArrayList<MonitorDetails> monitorList, boolean highToLow) {
        int n = monitorList.size();

        for (int i = 0; i < n - 1; i++) {
            int targetIndex = i; // Index of the minimum or maximum element

            for (int j = i + 1; j < n; j++) {
                if (highToLow) {
                    // Sort High-to-Low: Find the maximum element
                    if (monitorList.get(j).getAmount() > monitorList.get(targetIndex).getAmount()) {
                        targetIndex = j;
                    }
                } else {
                    // Sort Low-to-High: Find the minimum element
                    if (monitorList.get(j).getAmount() < monitorList.get(targetIndex).getAmount()) {
                        targetIndex = j;
                    }
                }
            }

            // Swap the found element with the element at index i
            if (targetIndex != i) {
                MonitorDetails temp = monitorList.get(i);
                monitorList.set(i, monitorList.get(targetIndex));
                monitorList.set(targetIndex, temp);
            }
        }
    }
}