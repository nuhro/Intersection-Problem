# MATLAB HS12 – Research Plan (Template)
(text between brackets to be removed)

> * Group Name: Crossrounds
> * Group participants names: Marcel Arikan, Nuhro Ego, Ralf Kohrt
> * Project Title: Intersections with pedestrians

## General Introduction

(States your motivation clearly: why is it important / interesting to solve this problem?)
(Add real-world examples, if any)
(Put the problem into a historical context, from what does it originate? Are there already some proposed solutions?)

We want to compare first one traffic intersection, either organised by a crossroad with a traffic light or by a roundabout. 
Secondly we add crosswalks immediately before the intersection with uniform distributed pedestrians and from time to time a tram interrupts the flow in the roundabout partially. 
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

The most interesting question we want to answer is whether the roundabout or the crossroad with lights is more efficient in terms of the parameters stated above.Comparing the behaviour in dependence of the flow rates. At which pedestrian/tram rate the crossroad has advantage? Is our model with a two line crossroad & roundabout working more efficient/giving remarkable different results? Are two or three intersections of the same type changing the results that we obtained by just one crossroad/roundabout? Especially when the lights are linked in case of the crossroads. Which model seems more secure for the participants? 


## Expected Results

(What are the answers to the above questions that you expect to find before starting your research?)

We expect a single roundabout to be more efficient, especially for low car flux rates. But with increasing pedestrian/tram flux the crossroad gets better. Moreover in case of two or three intersections the crossroad has advantages in keeping maximum car speed and periodical maximum flux(Schreckenberg-model), whereas with roundabouts cars have to slow down and the flux will be randomized after. We also expect that reducing the velocity a small bit before the roundabout makes it more efficient in real life due to people's psychology, so they would let the car have priority, but it's difficult to include that in our simulation.

## References 

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)

1.  Luka Piškorec, Simon Soller. <i>The effectiveness of signalisation and the priority to the right
simulated with Cellular Automata</i>. 2009.
2.  Nicola Bellomo, Christian Dogbe. <i>On the Modeling of Traffic and Crowds: A Survey of Models, Speculations, and Perspectives</i>. Society for Industrial and Applied Mathematics, 2011.
3.  Elmar Brockfeld, Robert Barlovic, Andreas Schadschneider, Michael Schreckenberg: <i>Optimizing traffic lights in a cellular automaton model for city traffic</i>. Physical Review E, Volume 64, 2001.
4.  Tony Wood, Bastian Bücheler. <i>Traffic Flow Comparison of Roundabouts and Crossroads</i>. 2010
5.  Dominik Eugster, Roman Fuchs. <i>Comparison of single-lane and two-lane roundabouts</i>. 2010

Extensions: two-lane model, Schreckenberg-model

## Research Methods

(Cellular Automata, Agent-Based Model, Continuous Modeling...) (If you are not sure here: 1. Consult your colleagues, 2. ask the teachers, 3. remember that you can change it afterwards)

We'll use Cellular Automata as the groups before. 

In a first step the cars drive in a stop-and-go manner without accelarating and braking time, 
but with reaction/pseudo-accelerating/braking time when entering or leaving(only roundabout) the intersection. The great unrealistic disadvantage this way is that the cars haven't got different velocities.  
In a second step we try to implement the Schreckenberg-model. 

## Other

(mention datasets you are going to use)
