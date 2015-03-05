package com.visualu.hdf5struct.cmpd;

import ch.systemsx.cisd.hdf5.HDF5CompoundDataList;

public class ChannelLocations {
    private String labels;
    private String type;
    private double theta;
    private double radius;
    private double X;
    private double Y;
    private double Z;
    private double sph_theta;
    private double sph_phi;
    private double sph_radius;
    private double urchan;
    private String ref;

    public ChannelLocations(String labels, double theta,
                            double radius, double X, double Y, double Z,
                            double sph_theta, double sph_phi, double sph_radius,
                            String type, double urchan, String ref) {
        this.labels = labels;
        this.type = type;
        this.theta = theta;
        this.radius = radius;
        this.X = X;
        this.Y = Y;
        this.Z = Z;
        this.sph_theta = sph_theta;
        this.sph_phi = sph_phi;
        this.sph_radius = sph_radius;
        this.urchan = urchan;
        this.ref = ref;
    }

    public ChannelLocations() {

    }

    /**
     * Static method to generate an array of ChannelLocations from a List of
     * attribute values, such as one returned by getCompoundData.
     * @param list the list of attribute values
     * @return an array of ChannelLocations objects generated by list
     */
    static public ChannelLocations[] fromList(HDF5CompoundDataList[] list) {

        ChannelLocations[] cls = new ChannelLocations[list.length];
        for (int i = 0; i < list.length; i++) {
            //System.out.println(list[i].get(0));
            cls[i] = new ChannelLocations(
               ((String) list[i].get(0)), ((Double) list[i].get(1)),
               ((Double) list[i].get(2)), ((Double) list[i].get(3)),
               ((Double) list[i].get(4)), ((Double) list[i].get(5)),
               ((Double) list[i].get(6)), ((Double) list[i].get(7)),
               ((Double) list[i].get(8)), ((String) list[i].get(9)),
               ((Double) list[i].get(10)), ((String) list[i].get(11)));
        }
        return cls;
    }

    /**
     * Summarizes the object
     * @return a decent String
     */
    public String toString() {
        return "ChannelLocations{labels=" + this.labels + ",type=" + this.type +
            ",theta=" + this.theta + ",radius=" + this.radius +
            ",X=" + this.X + ",Y=" + this.Y + ",Z=" + this.Z +
            ",sph_theta=" + this.sph_theta + ",sph_phi=" + this.sph_phi +
            ",sph_radius=" + this.sph_radius + ",urchan=" + this.urchan +
            ",ref=" + this.ref + "}";
    }
}
