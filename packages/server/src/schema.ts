export interface LocationInfo {
  ip: string;
  city: string;
  region: string;
  country: string;
  loc: string; // This could represent latitude and longitude as a string
  org: string;
  postal: string;
  timezone: string;
}

export interface IGoogleAuthTokenResponse {
  userId: string;
  email: string;
  name: string;
  profile: string;
  success: boolean;
}

export interface EmailOptions {
  to: string;
  subject: string;
  text?: string;
  html?: string;
}

export interface ApiEventData {
  name: string;
  data: any;
  timestamp: number; // in sec
}
