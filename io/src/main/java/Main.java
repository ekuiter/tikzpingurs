import de.ovgu.featureide.fm.core.base.IFeatureModel;
import de.ovgu.featureide.fm.core.base.impl.FMFormatManager;
import de.ovgu.featureide.fm.core.init.FMCoreLibrary;
import de.ovgu.featureide.fm.core.init.LibraryManager;
import de.ovgu.featureide.fm.core.io.IFeatureModelFormat;
import de.ovgu.featureide.fm.core.io.dimacs.DIMACSFormat;
import de.ovgu.featureide.fm.core.io.manager.FeatureModelIO;
import de.ovgu.featureide.fm.core.io.manager.FeatureModelManager;
import de.ovgu.featureide.fm.core.io.sxfm.SXFMFormat;
import de.ovgu.featureide.fm.core.io.uvl.UVLFeatureModelFormat;
import de.ovgu.featureide.fm.core.io.xml.XmlFeatureModelFormat;
import de.ovgu.featureide.fm.core.job.LongRunningMethod;
import de.ovgu.featureide.fm.core.job.LongRunningWrapper;
import de.ovgu.featureide.fm.core.job.SliceFeatureModel;
import de.ovgu.featureide.fm.core.analysis.cnf.manipulator.remove.CNFSlicer;
import de.ovgu.featureide.fm.core.analysis.cnf.formula.FeatureModelFormula;
import de.ovgu.featureide.fm.core.analysis.cnf.formula.CNFCreator;
import de.ovgu.featureide.fm.core.analysis.cnf.CNF;
import de.ovgu.featureide.fm.core.base.FeatureUtils;
import de.ovgu.featureide.fm.core.io.dimacs.DimacsWriter;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.Scanner;
import java.util.stream.Collectors;

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

        IFeatureModelFormat format = new SXFMFormat();
        String output = format.getInstance().write(featureModel);
        System.out.print(output);
    }
}
