import de.ovgu.featureide.fm.core.base.IFeatureModel;
import de.ovgu.featureide.fm.core.init.FMCoreLibrary;
import de.ovgu.featureide.fm.core.init.LibraryManager;
import de.ovgu.featureide.fm.core.io.IFeatureModelFormat;
import de.ovgu.featureide.fm.core.io.dimacs.DIMACSFormat;
import de.ovgu.featureide.fm.core.io.manager.FeatureModelIO;
import de.ovgu.featureide.fm.core.io.manager.FeatureModelManager;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        if (args.length > 1)
            throw new RuntimeException("usage: java -jar io.jar [file|-]");

        LibraryManager.registerLibrary(FMCoreLibrary.getInstance());

        IFeatureModel featureModel;
        if (args.length > 0 && !args[0].startsWith("-")) {
            Path inputPath = Paths.get(args[0]);
            if (!inputPath.toFile().isAbsolute()) {
                inputPath = Paths.get(".").resolve(inputPath);
            }
            featureModel = FeatureModelManager.load(inputPath);
        } else {
            StringBuilder sb = new StringBuilder();
            Scanner sc = new Scanner(System.in);
            while (sc.hasNextLine()) {
                sb.append(sc.nextLine());
                sb.append('\n');
            }
            featureModel = FeatureModelIO.getInstance()
                    .loadFromSource(sb, Paths.get(args.length > 0 ? args[0].replace("cnf", "dimacs") : "-.uvl"));
        }
        if (featureModel == null)
            throw new RuntimeException("failed to load feature model");

        IFeatureModelFormat format = new DIMACSFormat();
        String output = format.getInstance().write(featureModel);
        System.out.print(output);
    }
}
