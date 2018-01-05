# Capstone Project Proposal

## Project Description
Habits is an iOS app to help people form positive habits that support their larger life goals. The concept is that users will enter large goals that are often non-specific or measurable - such as getting fit or being a more involved parent. They will then enter habits that they think exemplify those goals and track completion, with feedback to show how they are progressing and to show areas for improvement.

## What problem does your project solve?
This project solves the problem of having goals that feel too big or unattainable, and also the problem of general "goal fatigue" - psychologically we don't usually feel successful or recognize gains when making small improvements.

## Who has this problem?
Anybody wanting to grow or change. With a new year, many people come up with resolutions but **as little as 8% stick to it**.

## How will your project solve this problem?
Research has shown that it is incredibly hard to change, but there are a couple of different ways one can increase the success. One of these is called tipping the scale - by adding multiple changes at once, you can prime your brain to adapt and form new habits. It also helps to have a deep, meaningful reason behind those goals. This project uses both of those approaches.

## What inputs does it need?
* Goals - large, and often non-specific statements, Ex: "I want to feel healthier mentally and physically", "I want to form more meaningful relationships"
* Habits - traits that exemplify a given goal, meant to be specific and measurable, Ex: "Lift weights", "Read for 30 minutes", "Call an old friend"

## What outputs does it produce?
* Habit completion - users will be able to see how often they are completing a given habit, encourages "don't break the chain" aka the Seinfeld methodology
* Goal progress - based on how a goal is set up (Ex: complete all associated habits, complete 50% of all habits), this would provide progress on that goal

## What technologies do you plan to use?
* Swift - front end / UI
* AWS Cognito - user profile management
* AWS Lambda - serverless computing
* AWS DynamoDB / RDS - storage
* API Gateway - API routing

## Prioritized Feature list (Label stretch features with STRETCH)
* CRUD for goals
* CRUD for habits - related to goal
* Display all daily habits
* Allow users to mark habits as completed
* Connect completed habits to parent goal - show that a goal was 50% completed, or that it was met 4 out of 7 days last week
* STRETCH - add frequency for habits, such as X times per week
* STRETCH - rate days, to identify trends or most valuable habits
