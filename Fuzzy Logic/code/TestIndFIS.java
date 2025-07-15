import net.sourceforge.jFuzzyLogic.FIS;

public class TestIndFIS {
    
    public static void main(String[] args) throws Exception {

        String fileName = "ind.fcl";
        FIS fis = FIS.load(fileName,true);

        if( fis == null ) { 
            System.err.println("Can't load file: '" + fileName + "'");
            return;
        }

        //FunctionBlock functionBlock = fis.getFunctionBlock("IndustrialController");
        //System.out.println(fis);

        /////////////////////////////////////////////////////////////////////////////////////////////
 
        fis.setVariable("dimensions", 4);
        fis.setVariable("surface", 0.3);
        fis.setVariable("tolerance", 0.2);

        fis.evaluate();

        System.out.println("surface: " + fis.getVariable("surface").getValue());
        System.out.println("tolerance: " + fis.getVariable("tolerance").getValue());
        System.out.println("dimensions: " + fis.getVariable("dimensions").getValue());
        System.out.printf("quality: %.2f \n", fis.getVariable("quality").getValue());
        double resVal = fis.getVariable("result").getValue();
        String res = (resVal < 0.9) ? "discarded" : "production";
        System.out.printf("result: %.2f", resVal);
        System.out.println(" -> " + res);

        /////////////////////////////////////////////////////////////////////////////////////////////

        fis.setVariable("dimensions", 5);
        fis.setVariable("surface", 0.35);
        fis.setVariable("tolerance", 1);

        fis.evaluate();

        System.out.println("surface: " + fis.getVariable("surface").getValue());
        System.out.println("tolerance: " + fis.getVariable("tolerance").getValue());
        System.out.println("dimensions: " + fis.getVariable("dimensions").getValue());
        System.out.printf("quality: %.2f \n", fis.getVariable("quality").getValue());
        resVal = fis.getVariable("result").getValue();
        res = (resVal < 0.9) ? "discarded" : "production";
        System.out.printf("result: %.2f", resVal);
        System.out.println(" -> " + res);

        /////////////////////////////////////////////////////////////////////////////////////////////

        fis.setVariable("dimensions", 5);
        fis.setVariable("surface", 2);
        fis.setVariable("tolerance", 1);

        fis.evaluate();

        System.out.println("surface: " + fis.getVariable("surface").getValue());
        System.out.println("tolerance: " + fis.getVariable("tolerance").getValue());
        System.out.println("dimensions: " + fis.getVariable("dimensions").getValue());
        System.out.printf("quality: %.2f \n", fis.getVariable("quality").getValue());
        resVal = fis.getVariable("result").getValue();
        res = (resVal < 0.9) ? "discarded" : "production";
        System.out.printf("result: %.2f", resVal);
        System.out.println(" -> " + res);
    }
}