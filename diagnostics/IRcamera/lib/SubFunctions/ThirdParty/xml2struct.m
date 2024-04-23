function [ s ] = xml2struct( file )
%Convert xml file into a MATLAB structure
% [ s ] = xml2struct( file )
%
% A file containing:
% <XMLname attrib1="Some value">
%   <Element>Some text</Element>
%   <DifferentElement attrib2="2">Some more text</Element>
%   <DifferentElement attrib3="2" attrib4="1">Even more text</DifferentElement>
% </XMLname>
%
% Will produce:
% s.XMLname.Attributes.attrib1 = "Some value";
% s.XMLname.Element.Text = "Some text";
% s.XMLname.DifferentElement{1}.Attributes.attrib2 = "2";
% s.XMLname.DifferentElement{1}.Text = "Some more text";
% s.XMLname.DifferentElement{2}.Attributes.attrib3 = "2";
% s.XMLname.DifferentElement{2}.Attributes.attrib4 = "1";
% s.XMLname.DifferentElement{2}.Text = "Even more text";
%
% Please note that the following characters are substituted
% '-' by '_dash_', ':' by '_colon_' and '.' by '_dot_'
%
% Written by W. Falkena, ASTI, TUDelft, 21-08-2010
% Attribute parsing speed increased by 40% by A. Wanner, 14-6-2011
    
    if (nargin < 1)
        clc;
        help xml2struct
        return
    end
    
    %check for existance
    if (exist(file,'file') == 0)
        %Perhaps the xml extension was omitted from the file name. Add the
        %extension and try again.
        if (isempty(strfind(file,'.xml')))
            file = [file '.xml'];
        end
        
        if (exist(file,'file') == 0)
            error(['The file ' file ' could not be found']);
        end
    end

    %read the xml file
    xDoc = xmlread(file);
    
    %parse xDoc into a MATLAB structure
    s = parseChildNodes(xDoc);
    
end

% ----- Subfunction parseChildNodes -----
function [children,ptext] = parseChildNodes(theNode)
    % Recurse over node children.
    children = struct;
    ptext = [];
    if theNode.hasChildNodes
        childNodes = theNode.getChildNodes;
        numChildNodes = childNodes.getLength;

        for count = 1:numChildNodes
            theChild = childNodes.item(count-1);
            [text,name,attr,childs] = getNodeData(theChild);
                        
            if (~strcmp(name,'#text') && ~strcmp(name,'#comment'))
                %XML allows the same elements to be defined multiple times,
                %put each in a different cell
                if (isfield(children,name))
                    if (~iscell(children.(name)))
                        %put existsing element into cell format
                        children.(name) = {children.(name)};
                    end
                    index = length(children.(name))+1;
                    %add new element
                    children.(name){index} = childs;
                    if(~isempty(text)) 
                        children.(name){index}.('Text') = text; 
                    end
                    if(~isempty(attr)) 
                        children.(name){index}.('Attributes') = attr; 
                    end
                else
                    %add previously unknown (new) element to the structure
                    children.(name) = childs;
                    if(~isempty(text)) 
                        children.(name).('Text') = text; 
                    end
                    if(~isempty(attr)) 
                        children.(name).('Attributes') = attr; 
                    end
                end
            elseif (strcmp(name,'#text'))
                %this is the text in an element (i.e. the parentNode) 
                if (~isempty(regexprep(text,'[\s]*','')))
                    if (isempty(ptext))
                        ptext = text;
                    else
                        %what to do when element data is as follows:
                        %<element>Text <!--Comment--> More text</element>
                        
                        %put the text in different cells:
                        % if (~iscell(ptext)) ptext = {ptext}; end
                        % ptext{length(ptext)+1} = text;
                        
                        %just append the text
                        ptext = [ptext text];
                    end
                end
            end
        end
    end
end

% ----- Subfunction getNodeData -----
function [text,name,attr,childs] = getNodeData(theNode)
    % Create structure of node info.
    
    %make sure name is allowed as structure name
    name = char(theNode.getNodeName);
    name = regexprep(name,'[-]','_dash_');
    name = regexprep(name,'[:]','_colon_');
    name = regexprep(name,'[.]','_dot_');

    attr = parseAttributes(theNode);
    if (isempty(fieldnames(attr))) 
        attr = []; 
    end
    
    %parse child nodes
    [childs,text] = parseChildNodes(theNode);
    
    if (isempty(fieldnames(childs)))
        %get the data of any childless nodes
        try
            %faster then if any(strcmp(methods(theNode), 'getData'))
            text = char(theNode.getData);
        catch
            %no data
        end
    end
    
end

% ----- Subfunction parseAttributes -----
function attributes = parseAttributes(theNode)
    % Create attributes structure.

    attributes = struct;
    if theNode.hasAttributes
       theAttributes = theNode.getAttributes;
       numAttributes = theAttributes.getLength;

       for count = 1:numAttributes
            %attrib = theAttributes.item(count-1);
            %attr_name = regexprep(char(attrib.getName),'[-:.]','_');
            %attributes.(attr_name) = char(attrib.getValue);

            %Suggestion of Adrian Wanner
            str = theAttributes.item(count-1).toString.toCharArray()';
            k = strfind(str,'='); 
            attr_name = str(1:(k(1)-1));
            attr_name = regexprep(attr_name,'[-]','_dash_');
            attr_name = regexprep(attr_name,'[:]','_colon_');
            attr_name = regexprep(attr_name,'[.]','_dot_');
            attributes.(attr_name) = str((k(1)+2):(end-1));
       end
    end
end