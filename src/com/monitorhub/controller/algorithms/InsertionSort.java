/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.monitorhub.controller.algorithms;

import com.monitorhub.model.MonitorDetails;
import com.monitorhub.model.overallsales;
import java.util.List;

/**
 *
 * @author Prajol Bimali
 * LMU ID: 23048651
 */
public class InsertionSort {
    public void sortByBrand(List<overallsales> overallsalesList) {
        int n = overallsalesList.size();

        for (int i = 1; i < n; i++) {
            overallsales key = overallsalesList.get(i);
            String keyBrand = key.getBrandName();
            int j = i - 1;

            // Move elements of overallsalesList[0..i-1], that are greater than keyBrand,
            // one position ahead of their current position
            while (j >= 0 && overallsalesList.get(j).getBrandName().compareTo(keyBrand) > 0) {
                overallsalesList.set(j + 1, overallsalesList.get(j));
                j--;
            }
            overallsalesList.set(j + 1, key);
        }
    }
    
    
    // In-place Insertion Sort Implementation
    public void SortByModelName(List<MonitorDetails> list) {
        for (int i = 1; i < list.size(); i++) {
            MonitorDetails key = list.get(i);
            int j = i - 1;
            while (j >= 0 && list.get(j).getModelName().toLowerCase().compareTo(key.getModelName().toLowerCase()) > 0) {
                list.set(j + 1, list.get(j));
                j--;
            }
            list.set(j + 1, key);
        }
    }
    
    
    
}
