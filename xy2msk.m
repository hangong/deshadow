function fmask = xy2msk( xys, imhw, ws )
%xy2msk converts user input to a shadow mask
%   Detailed explanation goes here

msk = zeros(imhw,'uint8');
% draw lines to the mask
sI = vision.ShapeInserter('Shape', 'Lines', ...
    'BorderColor', 'White');
msk = step(sI,msk,int32(reshape(xys,[],1)));
se = strel('disk',round(ws/2));
fmask = logical(imdilate(msk,se));

end
