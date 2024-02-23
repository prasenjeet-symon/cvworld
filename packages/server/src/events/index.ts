import { BehaviorSubject } from "rxjs";
import { ApiEventData } from "../schema";
import { AuthenticationEvent } from "./authentication.event";

export class ApiEventNames {
  public static readonly SEND_PASSWORD_RESET_LINK_EMAIL = "send_forgot_password_link";
  public static readonly SEND_RESET_PASSWORD_SUCCESS_EMAIL = "send_reset_password_success_email";
  public static readonly SEND_GREETING_EMAIL = "send_greeting_email";
  public static readonly SEND_FAREWELLS_EMAIL = "send_farewells_email";
  public static readonly USER_DELETED = "user_deleted";
  public static readonly USER_CREATED = "user_created";
  public static readonly USER_LOGIN = "user_login";
  public static readonly ADMIN_PLAN_CREATION = "admin_plan_creation";
  public static readonly SEND_SUBSCRIPTION_CANCELLATION_EMAIL = "send_subscription_cancellation_email";
  public static readonly SEND_SUBSCRIPTION_ACTIVATION_EMAIL = "send_subscription_activation_email";
}
/**
 *
 *
 *
 */
export class ApiEvent {
  private static instance: ApiEvent;
  private source: BehaviorSubject<ApiEventData> = new BehaviorSubject<ApiEventData>({
    name: "",
    data: {},
    timestamp: 0,
  });

  /**
   *
   *
   *
   *
   */
  private constructor() {
    this.source.subscribe((data) => {
      switch (data.name) {
        case ApiEventNames.SEND_GREETING_EMAIL:
          new AuthenticationEvent(data).sendGreetingEmail();
          break;

        case ApiEventNames.SEND_PASSWORD_RESET_LINK_EMAIL:
          new AuthenticationEvent(data).sendPasswordResetLink();
          break;

        case ApiEventNames.SEND_RESET_PASSWORD_SUCCESS_EMAIL:
          new AuthenticationEvent(data).sendPasswordResetSuccessful();
          break;

        default:
          break;
      }
    });
  }

  /**
   *
   *
   *
   */
  public static getInstance(): ApiEvent {
    if (!ApiEvent.instance) {
      ApiEvent.instance = new ApiEvent();
    }
    return ApiEvent.instance;
  }

  // Dispatch event
  public dispatch(name: string, data: any) {
    this.source.next({
      name: name,
      data: data,
      timestamp: Date.now() / 1000,
    });
  }
}
