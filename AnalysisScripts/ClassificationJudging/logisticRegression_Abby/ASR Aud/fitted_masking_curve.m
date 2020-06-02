function [r,F,mask] = fitted_masking_curve(lambda,X,f,B,A0,w0,SRType,TestType,m,s)

 % Generate the fitted curve
            r = (lambda./(sqrt(2)*pi)).* exp(-lambda^2./(2*((X-f).^2)));
            F = B - (A0.*lambda./(X - f).^2).*r./sqrt(4.*r.^2 + w0^2).*(X-f).*(X >=f);
            % Add masking, if present
            if(SRType == 1 && TestType == 2)
                mask = m*(X-s).*(X >= s);
                F = F + mask;
            end

end