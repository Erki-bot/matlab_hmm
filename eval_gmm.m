function [pr, mlg, p, mmserecon] = eval_gmm(gmm, data)
% function [logprob, mlgauss, mixprob, recon] = eval_gmm(gmm, data)
%
% Evaluate the log probability of each column of data given GMM gmm.
% mlgauss contains the index of the most likely gaussian in the GMM
% for each data point.  mixprob contains the log probs of each
% gaussian in the GMM for each data point.  recon contains the MMSE
% reconstruction of data given the GMM.
%
% 2005-11-20 ronw@ee.columbia.edu

[ndim, ndat] = size(data);

p = zeros(gmm.nmix, ndat);
pr = zeros(1,ndat)-Inf;

p = lmvnpdf(data, gmm.means, gmm.covars) ...
    + repmat(gmm.priors(:), [1, ndat]);
pr = logsum(p, 1);

if nargout > 1
  [mlg tmp] = ind2sub(size(p), find(p == repmat(max(p),gmm.nmix,1)));
end

if nargout >= 4
  % normalize p
  p = p-repmat(logsum(p,1), gmm.nmix, 1);

  mmserecon = gmm.means*exp(p);
end

