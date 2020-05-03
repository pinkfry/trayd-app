import 'package:flutter/cupertino.dart';
import 'package:job_posting_bidding_app/theme/theme.dart';
import 'package:job_posting_bidding_app/utils/utils.dart';

class Bid {
  String id;
  String name;
  String user_id;
  List<String> rating_review;
  int bid_amount;

  Bid({this.id, this.name, this.user_id, this.bid_amount, this.rating_review});

  static List<Bid> listFromJson(List<dynamic> json) {
    List<Bid> bids = List();
    if (json == null) return bids;
    for (int i = 0; i < json.length; i++) {
      Bid bid = Bid.fromJson(json[i]);
      bids.add(bid);
    }
    return bids;
  }

  factory Bid.fromJson(Map<String, dynamic> json) {
    ;
    return Bid(
      id: json["id"],
      name: json["name"],
      user_id: json["user_id"],
      bid_amount: json["bid_amount"],
    );
  }
}

class Expert {
  String created_on_date;
  String created_on_time;
  int hire_status = 0;
  int expert_status = 0;
  String id;
  String job_id;
  String user_id;

  Expert(
      {this.user_id,
      this.created_on_time,
      this.created_on_date,
      this.id,
      this.expert_status=0,
      this.hire_status=0,
      this.job_id});

  factory Expert.fromJson(Map<String, dynamic> json) => Expert(
        user_id: json["user_id"],
        created_on_time: json["created_on_time"],
        created_on_date: json["created_on_date"],
        id: json["_id"],
        expert_status:
            json["expert_status"] == null ? 0 : json["expert_status"],
        hire_status: json["hire_status"] == null ? 0 : json["hire_status"],
        job_id: json["job_id"],
      );
}

class Job {
  String created_on_date;
  String created_on_time;
  String selected_provider;
  int status;
  int expert_status;
  String id;
  String user_id;
  String service_name;
  String sub_service;
  String description;
  String title;
  String service_date;
  String service_time;
  String address;
  String bid_id;
  String selected_expert;
  int amount;
  List<Bid> bids;
  Color getStatusColor() {
    if (status == 1) {
      return ThemeConstant.color_6;
    } else if (status == 2) {
      return ThemeConstant.color_3;
    } else if (status == 0) {
      return ThemeConstant.color_5;
    }
    return ThemeConstant.color_5;
  }
  getStatus() {
    if (status == 1) {
      return "Hired";
    } else if (status == 2) {
      return "Completed";
    } else if (status == 0) {
      return "Open For Bidding";
    }
    return null;
  }

  getExpertHireStatus(String expert_id) {
    if(expert_id==selected_expert){
      if (status == 1) {
        return "Hired";
      } else if (status == 2) {
        return "Completed";
      } else if (status == 0) {
        return "Open For Bidding";
      }
    }
    if(status!=0){
      return "Someone else Hired";
    }
    return "Open For Bidding";
  }
  Color getExpertHireStatusColor(String expert_id) {
    if(expert_id==selected_expert){
      if (status == 1) {
        return ThemeConstant.color_6;
      } else if (status == 2) {
        return ThemeConstant.color_3;
      } else if (status == 0) {
        return ThemeConstant.color_5;
      }
    }
    if(status!=0){
      return ThemeConstant.color_4;
    }
    return ThemeConstant.color_5;
  }

  Job({
    this.user_id,
    this.service_name,
    this.id,
    this.description,
    this.status,
    this.expert_status,
    this.address,
    this.amount,
    this.created_on_date,
    this.created_on_time,
    this.selected_provider,
    this.service_date,
    this.title,
    this.service_time,
    this.sub_service,
    this.bids,
    this.selected_expert,
    this.bid_id,
  });

  static List<Job> listFromJson(List<dynamic> json) {
    List<Job> jobs = List();
    if (json == null) return jobs;
    for (int i = 0; i < json.length; i++) {
      Job job = Job.fromJson(json[i]);
      jobs.add(job);
    }
    return jobs;
  }

  factory Job.fromJson(Map<String, dynamic> json) => Job(
        user_id: json["user_id"],
        status: json["status"] == null ? -1 : json["status"],
        description: json["description"],
    title: json["title"],
        id: json["_id"],
        address: json["address"],
        amount: json["amount"] == null ? 0 : json["amount"],
        created_on_date: json["date"],
        created_on_time: json["time"],
        selected_provider: json["selected_provider"],
        service_date: json["service_date"],
        service_name: json["service_name"],
        service_time: json["service_time"],
        sub_service: json["sub_service"],
        bid_id: json["bid_id"],
        selected_expert: json["selected_expert"],
        expert_status: json["expert_status"],
        bids: json["bids"] == null ? null : Bid.listFromJson(json["bids"]),
      );
}

class JobsListResponse {
  bool success;
  List<Job> jobs;

  JobsListResponse({
    this.success,
    this.jobs,
  });

  factory JobsListResponse.fromJson(Map<String, dynamic> json) =>
      JobsListResponse(
        success: json["success"] == null ? false : json["success"],
        jobs: json["msg"] == null ? null : Job.listFromJson(json["msg"]),
      );
}

class ExpertJobObject {
  Job job;
  Expert expert;

  ExpertJobObject({this.job, this.expert});

  static List<ExpertJobObject> listFromJson(List<dynamic> json) {
    List<ExpertJobObject> jobs = List();
    if (json == null) return jobs;
    for (int i = 0; i < json.length; i++) {
      ExpertJobObject job = ExpertJobObject.fromJson(json[i]);
      jobs.add(job);
    }
    return jobs;
  }

  factory ExpertJobObject.fromJson(Map<String, dynamic> json) {
    ExpertJobObject a = ExpertJobObject(
      job: json["job"] == null ? null : Job.fromJson(json["job"]),
      expert: json["expert"] == null ? null : Expert.fromJson(json["expert"]),
    );
    return a;
  }
}

class ExpertGetAllResponse {
  bool success;
  List<ExpertJobObject> jobs;

  ExpertGetAllResponse({
    this.success,
    this.jobs,
  });

  factory ExpertGetAllResponse.fromJson(Map<String, dynamic> json) =>
      ExpertGetAllResponse(
        success: json["success"] == null ? false : json["success"],
        jobs: json["msg"] == null
            ? null
            : ExpertJobObject.listFromJson(json["msg"]),
      );
}

class Service {
  List<String> sub_services;
  List<String> tags;
  String createdAt;
  String id;
  String img_url;
  String service_name;

  Service(
      {this.id,
      this.createdAt,
      this.img_url,
      this.service_name,
      this.sub_services,
      this.tags});

  static List<Service> listFromJson(List<dynamic> json) {
    List<Service> services = List();
    if (json == null) return services;
    for (int i = 0; i < json.length; i++) {
      Service service = Service.fromJson(json[i]);
      services.add(service);
    }
    return services;
  }

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["_id"],
        createdAt: json["createdAt"],
        img_url: json["img_url"],
        service_name: json["service_name"],
        sub_services: Utils.stringListFromJson(json["sub_services"]),
        tags: Utils.stringListFromJson(json["tags"]),
      );
}

class ServiceListResponse {
  bool success;
  List<Service> services;

  ServiceListResponse({
    this.success,
    this.services,
  });

  factory ServiceListResponse.fromJson(Map<String, dynamic> json) =>
      ServiceListResponse(
        success: json["success"] == null ? false : json["success"],
        services:
            json["msg"] == null ? null : Service.listFromJson(json["msg"]),
      );
}
