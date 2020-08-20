
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class OrderKey {
    public static void main(String[] args) {


        String orderkey = "X102020SHH1F720201912T2TPXP4APL4WAEWE5YIAYIDYIHZ23Z3EZA9ZENZH2ZIE1PB1D74S11S17X28T64Z5KH6KK17P42FD8WH7K1V0F1G2NZ2N0E3L3QV34GR8W3110110165165190190";
        String countryCode = orderkey.substring(0,3);
        String modelYear = orderkey.substring(3,7);
        String modelNumber = orderkey.substring(7,13);
        String modeldataVersion = orderkey.substring(13,20);
        String exteriorColor = orderkey.substring(20,24);
        String interior = orderkey.substring(24,26);
        String featuresString = orderkey.substring(26);
// Split the features
        Matcher m = Pattern.compile("...").matcher(featuresString);
        Set<String> features = new HashSet<String>();
        while (m.find()) {
            features.add(m.group());
        }
        System.out.println(features);
    }
}
