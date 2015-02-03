%Classifies Likes(1) V/s Dislikes(0) based on threshold
function [classification_matrix] = classify(R,threshold)
    classification_matrix = (R >= threshold);
end