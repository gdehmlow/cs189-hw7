function [ recon_face ] = reconstruct( face, mean_face, efs, p )
% Reconstruct the given face from k top eigenfaces
% Input -
%   face: 1 x k array - masked face
%   mean_face: 1 x k array - mean face
%   efs: n x k matrix - n eigenfaces
%   p: number of eigenfaces to use to reconstruct the face
% Output -
%   recon_face: 1 x k array - reconstructed face

total_recon = ((face-mean_face)*efs')';
limited_efs_coeffs = total_recon(1:p,:);
ones_rep = ones(size(efs,2),1);
limited_efs_coeffs = limited_efs_coeffs*ones_rep';
recon_face = mean_face + sum(limited_efs_coeffs.*efs(1:p,:));

end

