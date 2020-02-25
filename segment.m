function result = segment()

  imgPath = 'C:\Users\os\Desktop\PH2Dataset\imgs\';
  maskPath = 'C:\Users\os\Desktop\PH2Dataset\masks\';
  
  imgType = '*.bmp'; 
  images  = dir([imgPath imgType]);
  masks = dir ([maskPath imgType]);
  Ni = length(images);
  Nm = length(images);

  % check images
  if( ~exist(imgPath, 'dir') || Ni<1 )
      display('Image Directory not found or no matching images found.');
  end
  % check masks
  if( ~exist(maskPath, 'dir') || Nm<1 )
      display('Mask Directory not found or no matching masks found.');
  end
  % check if number of images = number of masks
  if( Ni ~= Nm )
      display('Mask Directory not found or no matching masks found.');
      return;
  end
   
  for idx = 1:Ni
      img = imread([imgPath images(idx).name]);
      %ImageID(idx)=convertCharsToStrings(images(idx).name);
      %ImageID(idx) = strcat(images(idx).name{:});
      mask = imread([maskPath masks(idx).name]);
      
      %convert img to bw
      bwimg = rgb2gray(img);
      bwimg = im2bw(bwimg);
      
      filtrimg = bwareafilt(bwimg, 1);
      
      final = ~bwareaopen(~filtrimg, 1000);
      
      %apply bwlabel (8 connectivity)
      %labelimg = bwlabel(bwimg, 8);
      
      %apply median filter
      finalimg = medfilt2(final, [15 15]);
      
      finalimg = 1 - finalimg;
      
      %calculate diff
      diff = mask - finalimg;
      
      %calculate sum
      add = mask + finalimg;
      
      %find tp,tn,fp,fn
      
      fn = sum(diff(:) == 1);
      FalseNegative(idx) = fn;
      fp = sum(diff(:) == -1);
      FalsePositive(idx) = fp;
      tp = sum(add(:) == 2);
      
      TruePositive(idx) = tp;
      tn = sum(add(:) == 0);
      TrueNegative(idx) = tn;
      
      
      Sensitivity(idx) = tp/(tp+tn);
      Specificity(idx) = fp/(tn+fp);
      
      DiceCoefficient(idx) = (2*tp)/(fn + (2*tp) + fp);
      
  end
  TruePositive = TruePositive';
  TrueNegative =  TrueNegative';
  FalseNegative =  FalseNegative';
  FalsePositive = FalsePositive';
  Sensitivity = Sensitivity';
  Specificity = Specificity';
  DiceCoefficient= DiceCoefficient';
  
  
  result = table(TruePositive, TrueNegative, FalseNegative, FalsePositive, Sensitivity, Specificity, DiceCoefficient);
  
end



