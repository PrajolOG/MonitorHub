/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.monitorhub.controller.algorithms;


import com.monitorhub.model.MonitorDetails;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Prajol Bimali
 * LMU ID: 23048651
 */



public class MergeSort {

    // Method to perform merge sort on the list based on stock
    public List<MonitorDetails> mergeSort(List<MonitorDetails> monitorList, boolean highToLow) {
        if (monitorList.size() < 2) return monitorList;

        int mid = monitorList.size() / 2;

        // Recursively sort both halves and merge them
        return merge(
            mergeSort(new ArrayList<>(monitorList.subList(0, mid)), highToLow),
            mergeSort(new ArrayList<>(monitorList.subList(mid, monitorList.size())), highToLow),
            highToLow
        );
    }

    private List<MonitorDetails> merge(List<MonitorDetails> left, List<MonitorDetails> right, boolean highToLow) {
        List<MonitorDetails> merged = new ArrayList<>();
        int i = 0, j = 0;

        while (i < left.size() && j < right.size()) {
            boolean condition = highToLow ? 
                left.get(i).getStock() >= right.get(j).getStock() : 
                left.get(i).getStock() <= right.get(j).getStock();

            merged.add(condition ? left.get(i++) : right.get(j++));
        }

        // Add remaining elements from left or right
        merged.addAll(left.subList(i, left.size()));
        merged.addAll(right.subList(j, right.size()));

        return merged;
    }
}

