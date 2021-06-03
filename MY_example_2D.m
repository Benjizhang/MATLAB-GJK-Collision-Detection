% Example script for GJK function
%   Animates two objects on a collision course and terminates animation
%   when they hit each other. Loads vertex and face data from
%   SampleShapeData.m. See the comments of GJK.m for more information
%
%   Most of this script just sets up the animation and transformations of
%   the shapes. The only key line is:
%   collisionFlag = GJK(S1Obj,S2Obj,iterationsAllowed)
%
%   Matthew Sheen, 2016
clc;clear all;close all

%How many iterations to allow for collision detection.
iterationsAllowed = 6;

% Make a figure
fig = figure;
hold on

% Load sample vertex and face data for two convex polyhedra
% SampleShapeData;

% Make shape 1
clear S1
% S1.Vertices = [2 4; 5 4; 5 6; 2 6];
S1.Vertices = [2 1 0; 6 1 0; 6 6 0; 2 6 0];
S1.Faces = [1 2 3 4];
S1.FaceVertexCData = jet(size(S1.Vertices,1));
S1.FaceColor = 'interp';
S1Obj = patch(S1);

% Make shape 2
clear S2
% S2.Vertices = [5 0; 5 2; 8 2; 8 0];
S2.Vertices = [5 0 0; 5 2 0; 8 2 0; 8 0 0];
S2.Faces = [1 2 3 4];
S2.FaceVertexCData = jet(size(S2.Vertices,1));
S2.FaceColor = 'interp';
S2Obj = patch(S2);

% Do collision detection
% -- 3D --
% % % collisionFlag = GJK(S1Obj,S2Obj,iterationsAllowed);
% -- 2D --
% collisionFlag = GJK_optimal(S1Obj,S2Obj,iterationsAllowed);
% collisionFlag = GJK_2D(S1Obj,S2Obj,iterationsAllowed);


hold off
axis equal
axis([-10 10 -10 10])
fig.Children.Visible = 'off'; % Turn off the axis for more pleasant viewing.
fig.Color = [1 1 1];
rotate3d on;


%Move them through space arbitrarily.
S1Coords = S1Obj.Vertices;
S2Coords = S2Obj.Vertices;

S1Rot = eye(3,3); % Accumulate angle changes

% Make a random rotation matix to rotate shape 1 by every step
S1Angs = 0.1*rand(3,1); % Euler angles
S1Angs(1) =0;
S1Angs(2) =0;
sang1 = sin(S1Angs);
cang1 = cos(S1Angs);
cx = cang1(1); cy = cang1(2); cz = cang1(3);
sx = sang1(1); sy = sang1(2);  sz = sang1(3);

S1RotDiff = ...
    [          cy*cz,          cy*sz,            -sy
    sy*sx*cz-sz*cx, sy*sx*sz+cz*cx,          cy*sx
    sy*cx*cz+sz*sx, sy*cx*sz-cz*sx,          cy*cx];

S2Rot = eye(3,3);

% Make a random rotation matix to rotate shape 2 by every step
S2Angs = 0.1*rand(3,1); % Euler angles
S2Angs(1) =0;
S2Angs(2) =0;
sang2 = sin(S2Angs);
cang2 = cos(S2Angs);
cx = cang2(1); cy = cang2(2); cz = cang2(3);
sx = sang2(1); sy = sang2(2); sz = sang2(3);

S2RotDiff = ...
    [          cy*cz,          cy*sz,            -sy
    sy*sx*cz-sz*cx, sy*sx*sz+cz*cx,          cy*sx
    sy*cx*cz+sz*sx, sy*cx*sz-cz*sx,          cy*cx];


% Animation loop. Terminates on collision.
end_cond = -3;
for i = 3:-0.01:end_cond
    S1Rot = S1RotDiff*S1Rot;
    S2Rot = S2RotDiff*S2Rot;
    
    S1Obj.Vertices = ((S1Rot*S1Coords') + [3,  i, 0]'*ones(1,size(S1Coords,1)))';
    S2Obj.Vertices = ((S2Rot*S2Coords') + [4, -i, 0]'*ones(1,size(S2Coords,1)))';
    
    % Do collision detection
    % % % collisionFlag = GJK(S1Obj,S2Obj,iterationsAllowed);
    collisionFlag = GJK_2D(S1Obj,S2Obj,iterationsAllowed);
    
    drawnow;
    
    if collisionFlag
        t = text(3,3,3,'Collision!','FontSize',30);
        break;
    end
end
