# MATLAB HS12 – Research Plan (Template)
(text between brackets to be removed)

> * Group Name: (be creative!)
> * Group participants names: Marcel Arikan, Nuhro Ego
> * Project Title: (can be changed)

## General Introduction

(States your motivation clearly: why is it important / interesting to solve this problem?)
(Add real-world examples, if any)
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)

We want to compare first one traffic intersection, either organised by a crossroad with a traffic light or by a roundabout. 
Secondly we add crosswalks with uniform distributed pedestrians and from time to time a tram the flow in a roundabout partially. 
If we are capable we'd like to place two or three of the same type of intersection one after another in a line. 

When I go buying bread for breakfast, I have to cross the Albisriederplatz in Zürich. It's a crossing with four streets, 
including two tram- and buslines stopping in the middle. 
So many people cross to catch a tram and make the traffic jam even worse. They have priority, but the cars can't wait too long in the circle. 
The result of this difficult nonverbal communication are many dangerous misunderstandings. 
Next to the Albisriederplatz are several intersections more and the bottleneck of the Hardbrücke. 

## The Model

(Define dependent and independent variables you want to study. Say how you want to measure them.) (Why is your model a good abtraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)

We want to define the efficiency of the model by the number of cars entering our simulation region devided by the number of leaving it in a unit time step. 

Our main parameter is the (intensity) flow of cars. Secondly it is the numper of disturbing pedestrians and trams per time. 
If we manage to place two intersections one after another, a variable could be the distance between them.

The control of the traffic light should be optimized experimentally, say fixed periods as long as possible, 
depending on the car flow and the waiting space there is before a crossroad. 

## Fundamental Questions

(At the end of the project you want to find the answer to these questions)
(Formulate a few, clear questions. Articulate them in sub-questions, from the more general to the more specific. )

## Expected Results

(What are the answers to the above questions that you expect to find before starting your research?)


## References 

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)
mehrspurig

## Research Methods

(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)

cellular automata 

first: cars drive in a stop-and-go manner without accelarating and braking time, 
but with reaction time when entering or leaving the intersection. 

possible and more realistic extension with Schreckenberg-model

## Other

(mention datasets you are going to use)
