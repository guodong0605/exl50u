% Return structures of physical constants and conversion factors between units.
%   [constants, conversions] = defineConstants
%
%   Example: build a structure FC with values of all fundamental constants
%      C = defineConstants;
%      C_fields = fieldnames(C);
%      for cc = 1:length(C_fields)
%          FC.(C.(char(C_fields{cc})).symbol) = C.(char(C_fields{cc})).val;
%      end
%      FC = orderfields(FC);
%      clear C C_fields cc
%
%   All constants are in MKSA units.
%
%   How to use:
%   This function should be called when constants or conversion factors are needed.
%
% Reference: http://physics.nist.gov/cuu/Constants/
%