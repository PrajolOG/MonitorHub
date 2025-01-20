/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.monitorhub.datastructure;

/**
 *
 * @author Prajol
 * LMU ID: 23048651
 */

import java.util.Stack;

public class ActivityStack {
    private Stack<String> activityStack;

    public ActivityStack() {
        activityStack = new Stack<>();
    }

    
    
    /**
     * Adds an activity to the top of the activity stack.
     *
     * @param activity The name or description of the activity to add (String).
     */
    public void addActivity(String activity) {
        activityStack.push(activity);
    }

    
    
    /**
     * Removes and returns the most recently added activity from the top of the stack.
     *
     * @return The removed activity (String) or null if the stack is empty.
     */
    public String removeActivity() {
        if (!activityStack.isEmpty()) {
            return activityStack.pop();
        }
        return null;
    }
    


    /**
     * Returns the entire activity stack (for display or other purposes).
     *
     * @return A Stack<String> containing all activities in their order of insertion.
     */
    public Stack<String> getActivities() {
        return activityStack;
    }
}
