% This file contains the configuration but no Implementation
% Based on such a file multiple experiments can be run with the same model
clear; clc;

addpath Model;
addpath Visualization;
% -------------------------------------------------------------------------
% Create highway model
% -------------------------------------------------------------------------
nLanes = 3;                 %Anzahl an Spuren
nCells = 100;               %Länge der Strecke
highway = Highway(nLanes, nCells, LCG(912915758));

highway.useCellfun % 0
highway.rng.rand % .2533

rng.rand = @rand; rng.randi = @randi;
highway = Highway(nLanes, nCells, rng, "useCellfun");

highway.useCellfun % 1
highway.rng.rand() % ???        Nachteil: Klammern benötigt
