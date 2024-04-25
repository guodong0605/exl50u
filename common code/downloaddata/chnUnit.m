function unit=chnUnit(strname)
lettersOnly = regexprep(strname, '[^a-zA-Z]', '');
strname2=lower(lettersOnly);
switch strname2
    case 'ip'
        unit='kA';
    case 'hcnne'
        unit='10^{17}/m^2';
    case 'loopv'
        unit='V';
    case 'csexp'
        unit='A';
    case 'psexp'
        unit='A';
    case 'zp'
        unit='m';
    case  'rp'
        unit='m';
    otherwise
        unit='V';
end
end